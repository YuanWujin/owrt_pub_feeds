--[[
-- LuCI model page for the basic configuration of the output module
-- Copyright Karl Palsson <karlp@etactica.com> Jul 2018
-- Licensed under your choice of Apache2, ISC, MIT, or BSD 2 clause
--]]
local _ = luci.i18n.translate

m = Map("output-thingsboard", "Message Output Daemon - ThingsBoard",
	_([[This service handles bridging eTactica live stream data, and posting it to your a ThingsBoard instance.
    <h4>Before you start</h4>
    You should <em>already</em> have your <strong>Access token</strong> for your ThingsBoard device..
    <h4>About ThingsBoard <img src="/resources/images/TB-logo.png" height="31" style="vertical-align: middle" alt="ThingsBoard logo"/></H4>
    <p/>
    From their website:
    <blockquote>
    ThingsBoard IoT Platform -  Device management, data collection, processing and visualization for your IoT solution
    </blockquote>
    <p/>
    <a href="http://www.thingsboard.io/" target="_blank">Visit their site for more information</a>
    ]]))

s = m:section(TypedSection, "general", _("Configuration"))
s.anonymous = true
s:option(Flag, "enabled", _("Enable this output service"),
	_([[The service will not start until this is checked]]))
s:option(Value, "address", _("Address"),
	_([[Provided by ThingsBoard, the host name of your thingsboard, eg: iot.example.org or iot.example.com:8883]]))
s:option(Flag, "use_tls", _("Enable transport security (TLS/SSL)"),
	_([[This depends on how your ThingsBoard administrator has configured your system]]))
s:option(Value, "accesstoken", _("Access Token"),
	_([[Provided by ThingsBoard, identifies this device]]))

return m
