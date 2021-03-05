version <- "1.0"
name <- "Exceptions"
short_name <- "exceptions"
dependencies <- "logger"

function OnLoad() {
	logger.SetLevel(logger.LogLevel.ALL)
	logger.SetLocation(logger.LogLocation.CONSOLE)
	logger.SetTimeType(logger.TimeType.CLOCK)
}


function TestParameters(scope, types) {
	local stackInfos = getstackinfos(2)
	local funcInfos = scope[stackInfos.func].getinfos()
	
	for(local i = 0; i < funcInfos.parameters.len() && i < types.len(); i++) {
		local parameter = stackInfos.locals[funcInfos.parameters[i]]
		if(types[i] != null) {
			TestParameterType(parameter, funcInfos.parameters[i], types[i])
		}
	}
}

function TestParameterType(param, paramName, type) {
	if(typeof(param) != type) {
		throw "Parameter \"" + paramName + "\" should be of type \"" + type + "\" but is of type \"" + typeof(param) + "\""
	}
}