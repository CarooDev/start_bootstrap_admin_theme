#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'
require 'fileutils'

TARGET_VIEWS_PATH = Pathname.new('app/views/start_bootstrap_admin_theme/pages/')
START_BOOTSTRAP_PATH = Pathname.new(ARGV[0])

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

def copy_theme_files
  cp_r_with_parents(START_BOOTSTRAP_PATH.glob('*.html'), TARGET_VIEWS_PATH)

  cp_start_bootstrap_dir_to_target_assets_dir('img', 'images')
  cp_start_bootstrap_dir_to_target_assets_dir('js', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('css', 'stylesheets')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/bootstrap/js', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/chart.js', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/datatables', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/jquery', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/jquery-easing', 'javascripts')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/fontawesome-free/css', 'stylesheets')
  cp_start_bootstrap_dir_to_target_assets_dir('vendor/fontawesome-free/webfonts', 'images')
end

def update_paths_in_theme_files
  Pathname.new(TARGET_VIEWS_PATH).glob('*.html').each do |pathname|
    contents = pathname.read

    updated_contents =
      contents
        .gsub('href="vendor/', 'href="/assets/start_bootstrap_admin_theme/vendor/')
        .gsub('href="css/', 'href="/assets/start_bootstrap_admin_theme/css/')
        .gsub('src="vendor/', 'src="/assets/start_bootstrap_admin_theme/vendor/')
        .gsub('src="js/', 'src="/assets/start_bootstrap_admin_theme/js/')
        .gsub('src="img/', 'src="/assets/start_bootstrap_admin_theme/img/')

    pathname.write(updated_contents)
  end
end

delete_target_paths
copy_theme_files
update_paths_in_theme_files
