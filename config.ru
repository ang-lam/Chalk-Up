require './config/environment'

use Rack::MethodOverride

use WorkoutsController
use UsersController
run ApplicationController
