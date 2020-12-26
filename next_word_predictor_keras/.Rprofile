options(repos=structure(c(CRAN="https://cloud.r-project.org/")))

VIRTUALENV_NAME = 'myEnv'


if (Sys.info()[['user']] == 'shiny'){
  
  Sys.setenv(PYTHON_PATH = 'python3')
  Sys.setenv(VIRTUALENV_NAME = paste0(VIRTUALENV_NAME, '/')) 
  Sys.setenv(RETICULATE_PYTHON = paste0(VIRTUALENV_NAME, '/bin/python/'))
}  
# else if (Sys.info()[['user']] == 'rstudio-connect'){
#   
#   
#   Sys.setenv(PYTHON_PATH = '/opt/python/3.7.6/bin/python')
#   Sys.setenv(VIRTUALENV_NAME = paste0(VIRTUALENV_NAME, '/'))
#   Sys.setenv(RETICULATE_PYTHON = paste0(VIRTUALENV_NAME, '/bin/python/'))
#   
# } else {
#   
#   # Running locally
#   options(shiny.port = 7450)
#   Sys.setenv(PYTHON_PATH = 'python3')
#   Sys.setenv(VIRTUALENV_NAME = VIRTUALENV_NAME) # exclude '/' => installs into ~/.virtualenvs/
#  
# }
