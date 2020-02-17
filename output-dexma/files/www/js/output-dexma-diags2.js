function Post(j) {
	var self = this;
	self.ok = ko.observable(j.ok);
	self.at = ko.observable(j.at);
	self.ts = ko.observable(j.ts);
	self.n = ko.observable(j.n);
	self.err = ko.observable(j.err);
	self.retry = ko.observable(j.retry);
}

function DexmaID(label, meta) {
	var self = this;
	meta = meta ? meta : {}
	self.label = ko.observable(label);
	self.hasModel = ko.observable(meta.has_model);
}

function PageModel(pagename) {
	var self = this;
	self.active = ko.observable();
	self.qd = ko.observable();
	self.posts = ko.observableArray();
	self.dids = ko.observableArray();
	self.errNotSupported = ko.observable();
	self.errNotConnected = ko.observable();

    self.totalWith = ko.computed(function() {
        return ko.utils.arrayFilter(self.dids(), function(did) {
            return did.hasModel();
        });
    });
    self.totalWithout = ko.computed(function() {
        return ko.utils.arrayFilter(self.dids(), function(did) {
            return !did.hasModel();
        });
    });

	self.onMessage = function(message) {
		var p;
		try {
			p = JSON.parse(message.payloadString);
			self.active(true);
		} catch (e) {
			// This is the null on exit.
			self.active(false);
			return;
		}
		console.log("got a message?!", p);
		self.active(true); // if the message is real, we're alive!
		// TODO - handle getting a null here to mark active as false?
		self.qd(p.qd);
		self.posts([]);
		Array.from(p.posts).forEach(function(v, i, a) {
			self.posts.push(new Post(v));
		});
		self.dids([]);
		Object.keys(p.dids).forEach(function(v, i, m) {
			self.dids.push(new DexmaID(v, p.dids[v]));
		});

	}

	self.mqh = new MQTTHandler(pagename, self.onMessage, ["status/local/json/output-dexma/state"], self.errNotSupported, self.errNotConnected);
}

function MQTTHandler(name, msgHandler, sublist, supportedCB, connectedCB) {
	var self = this;

	self.sublist = sublist;
	self.errNotSupported = supportedCB ? supportedCB : function(a) { console.log("Default not supported handler", a) };
	self.errNotConnected = connectedCB ? connectedCB : function(a) { console.log("Default not connected handler", a) };

    self.wsLostHandler = function(obj) {
        self.errNotConnected(obj.errorMessage);
        setTimeout(self.wsDoConnect, 5000);
    };

    self.wsConnected = function(obj) {
        self.errNotConnected(false);
        function subFail(obj) {
            self.mqclient.disconnect();
            setTimeout(self.wsDoConnect, 5000);
        }

        function request_hwc() {
            var m = new Paho.MQTT.Message("{}");
            m.destinationName = "command/local/json/getmodbusdevicemodel";
            self.mqclient.send(m);
            self.hwc_attempts(self.hwc_attempts + 1);
            setTimeout(function() {
                if (!self.hwc_received()) {
                    request_hwc();
                }
            }, 5000);
        }

        self.sublist.forEach(function(v, i, a) {
            self.mqclient.subscribe(v, {qos: 0, onFailure: subFail})
        });
    };

    self.wsDoConnect = function() {
        self.mqclient.connect({
            mqttVersion: 4,
            onFailure: self.wsLostHandler,
            onSuccess: self.wsConnected
        });
        self.errNotConnected(false);
    };

    try {
        self.mqclient = new Paho.MQTT.Client(location.hostname, 8083,
            name + (Math.random() + 1).toString(36).substring(2,8));
        self.mqclient.onConnectionLost = self.wsLostHandler;
        self.mqclient.onMessageArrived = msgHandler;

        // Ensures that if we navigate away, that we don't call any error callbcks
		window.addEventListener('beforeunload', function() {
			self.mqclient.onConnectionLost = function() {};
		})

        self.wsDoConnect();
    } catch (e) {
        self.errNotSupported(true);
    }
}


document.addEventListener("DOMContentLoaded", function(event) {
    mymodel = new PageModel("output-dexma-diags2");
    ko.applyBindings(mymodel);
});
