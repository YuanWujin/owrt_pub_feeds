--[[
-- LuCI model page for the basic configuration of the output module
-- Copyright Karl Palsson <karlp@etactica.com> Sept 2018
-- Licensed under your choice of Apache2, ISC, MIT, or BSD 2 clause
--]]
local _ = luci.i18n.translate

m = Map("output-senseone", "Message Output Daemon - SenseOne",
	_([[This service handles bridging eTactica live stream data, and posting it to your SenseOne account.
    <h4>Before you start</h4>
    You should <em>already</em> have an SenseOne account.
    <h4>More information</H4>
    <p/>
    From their website:
    <blockquote>
<p>At SenseOne, our vision is to deliver IoT solutions that exceed customer’s expectations.

<p>We came to work on the Internet of Things from on the ground challenges to connect assets and systems inside commercial and industrial buildings.

<p>From a business standpoint, we have created an IoT middleware platform that is capable of reducing the lifecycle cost and effort of multiple integrations that are central to any IoT implementation.

<p>From a technical standpoint, we have focused on interoperability requirements and developed a scalable IoT middleware layer for integrating heterogeneous systems and enabling connected environments.
    </blockquote>
    <p/>
    <a href="https://www.senseone.io/" target="_blank">
        <img src="/resources/images/senseone.png" height="31" style="vertical-align: middle" alt="SenseOne logo"/><br>
        Visit their site for more information
    </a>
    </p>
    ]]))

s = m:section(TypedSection, "general", _("Configuration"))
s.anonymous = true
s:option(Flag, "enabled", _("Enable this output service"),
        _([[The service will not start until this is checked]]))
s:option(Value, "username", _("The MQTT bridge username"),
	_([[Provided by SenseOne, unique for your account]]))
s:option(Value, "password", _("The MQTT bridge password"),
	_([[Provided by SenseOne, unique for your account]]))
s:option(Value, "address", _("The MQTT broker address"),
	_([[Provided by SenseOne, normally standard]]))

return m
