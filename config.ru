require './config/environment'


# can delete this if statement

# if ActiveRecord::Migrator.needs_migration?
#   raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end

use Rack::MethodOverride

use UsersController
run ApplicationController
