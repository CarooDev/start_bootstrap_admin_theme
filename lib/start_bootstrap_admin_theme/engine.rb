module StartBootstrapAdminTheme
  class Engine < ::Rails::Engine
    isolate_namespace StartBootstrapAdminTheme

    initializer 'start_bootstrap_admin_theme.assets.precompile' do |app|
      asset_paths = Pathname.new(__FILE__).join('../../../vendor/assets').glob('**/*.*').map do |path|
        path.to_s
          .sub(%r{\A.*/vendor/assets/\w+/}, '')
          .sub(/\.erb/, '')
      end

      app.config.assets.precompile += asset_paths
    end
  end
end
