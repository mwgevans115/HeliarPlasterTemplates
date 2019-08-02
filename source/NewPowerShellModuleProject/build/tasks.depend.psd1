@{
	BuildHelpers = 'latest'
<%
if ($PLASTER_PARAM_TestFramework -ne 'None') {
"	$PLASTER_PARAM_TestFramework = 'latest'"
}
if ($PLASTER_PARAM_BuildAutomation -ne 'None') {
"	$PLASTER_PARAM_BuildAutomation = 'latest'"
}
%>
}