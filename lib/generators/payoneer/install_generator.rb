module Payoneer
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc 'Creates a sample Payoneer initializer.'

      def copy_initializer
        copy_file 'payoneer.rb', 'config/initializers/payoneer.rb'
      end
    end
  end
end
