// Import and register all your controllers from the importmap via controllers/**/*_controller
import { hello_controller } from "controllers/hello_controller"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", hello_controller)
