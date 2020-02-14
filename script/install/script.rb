#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'
require 'fileutils'

TARGET_VIEWS_PATH = Pathname.new('app/views/start_bootstrap_admin_theme/pages/')
START_BOOTSTRAP_PATH = Pathname.new(ARGV[0])
FONTAWESOME_RELATIVE_PATH = 'vendor/fontawesome-free/css'
START_BOOTSTRAP_FONTAWESOME_PATH = START_BOOTSTRAP_PATH.join(FONTAWESOME_RELATIVE_PATH)

def target_assets_path(asset_type)
  Pathname.new("vendor/assets/#{asset_type}/start_bootstrap_admin_theme/")
end

def cp_r_with_parents(src, dest)
  FileUtils.mkdir_p(dest)
  FileUtils.cp_r(src, dest)
end

def cp_start_bootstrap_dir_to_target_assets_dir(start_bootstrap_relative_path, target_assets_relative_path)
  start_bootstrap_relative_pathname = Pathname.new(start_bootstrap_relative_path)

  cp_r_with_parents(
    START_BOOTSTRAP_PATH.join(start_bootstrap_relative_pathname),
    target_assets_path(target_assets_relative_path).join(start_bootstrap_relative_pathname.parent)
  )
end

def delete_target_paths
  target_paths = [
    TARGET_VIEWS_PATH, target_assets_path('images'), target_assets_path('javascripts'), target_assets_path('stylesheets')
  ]

  target_paths.each { |path| path.rmtree if path.directory? }
end

def fontawesome_stylesheets_target_path
  @fontawesome_stylesheets_target_path ||= target_assets_path('stylesheets').join(FONTAWESOME_RELATIVE_PATH)
end

def cp_html_files
  FileUtils.mkdir_p(TARGET_VIEWS_PATH)

  START_BOOTSTRAP_PATH.glob('*.html').each do |html_pathname|
    FileUtils.cp(html_pathname, TARGET_VIEWS_PATH.join("#{html_pathname.basename}.erb"))
  end
end

def cp_fontawesome_css_files
  FileUtils.mkdir_p(fontawesome_stylesheets_target_path)

  START_BOOTSTRAP_FONTAWESOME_PATH.glob('*.css').each do |css_pathname|
    FileUtils.cp(css_pathname, fontawesome_stylesheets_target_path.join("#{css_pathname.basename}.erb"))
  end
end

def delete_map_files
  target_assets_path('javascripts').glob('**/*.map') do |map_pathname|
    map_pathname.delete
  end
end

def copy_theme_files
  cp_html_files

  cp_start_bootstrap_dir_to_target_assets_dir('img', 'images')
  cp_start_bootstrap_dir_to_target_assets_dir('js', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('css', 'stylesheets')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/bootstrap/js', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/chart.js', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/datatables', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/jquery', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/jquery-easing', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/fontawesome-free/webfonts', 'images')

  cp_fontawesome_css_files

  delete_map_files
end

def update_paths_in_html_files
  Pathname.new(TARGET_VIEWS_PATH).glob('*.html.erb').each do |pathname|
    updated_contents = pathname.read

    updated_contents.gsub!(%r{<link href="vendor/(.*?)".*\>}) do
      "<%= stylesheet_link_tag 'start_bootstrap_admin_theme/vendor/#{$1}' %>"
    end

    updated_contents.gsub!(%r{<link href="css/(.*?)".*\>}) do
      "<%= stylesheet_link_tag 'start_bootstrap_admin_theme/css/#{$1}' %>"
    end

    updated_contents.gsub!(%r{<script src="vendor/(.*?)".*\>}) do
      "<%= javascript_include_tag 'start_bootstrap_admin_theme/vendor/#{$1}' %>"
    end

    updated_contents.gsub!(%r{<script src="js/(.*?)".*\>}) do
      "<%= javascript_include_tag 'start_bootstrap_admin_theme/js/#{$1}' %>"
    end

    updated_contents.gsub!(%r{src="img/(.*?)"}) do
      "src='<%= image_path('start_bootstrap_admin_theme/img/#{$1}')%>'"
    end

    pathname.write(updated_contents)
  end
end

def update_paths_in_fontawesome_css_files
  fontawesome_stylesheets_target_path.glob('*.css.erb').each do |pathname|
    updated_contents = pathname.read

    updated_contents.gsub!(%r{url\("\.\.(.*?)"\)}) do
      %Q{url("<%= asset_path('start_bootstrap_admin_theme/vendor/fontawesome-free/#{$1}') %>")}
    end

    updated_contents.gsub!(%r{url\(\.\.(.*?)\)}) do
      %Q{url(<%= asset_path('start_bootstrap_admin_theme/vendor/fontawesome-free/#{$1}') %>)}
    end

    pathname.write(updated_contents)
  end
end

delete_target_paths
copy_theme_files
update_paths_in_html_files
update_paths_in_fontawesome_css_files
