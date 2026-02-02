# used as a launch target for debugging in vscode. should not be used generally,
# see app.R for standard app launch.
# the vscode launch configuration handles loading the package with pkgload
app <- run_app()
# need to print the app in order to launch it in vscode
print(app)
