'use strict';
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

/**
* Check if an object is empty.
*/
function isEmpty(obj) {
    if (obj == null) return true;
    if (obj.length > 0)    return false;
    if (obj.length === 0)  return true;
    if (typeof obj !== "object") return true;
    for (var key in obj) {
        if (hasOwnProperty.call(obj, key)) return false;
    }
    return true;
}

function webhook(req, res) {
  var admissionRequest = req.body;
  var object = admissionRequest.request.object;

  var allowed = false;
  if (!isEmpty(object.metadata.annotations) && !isEmpty(object.metadata.annotations.chapter) && object.metadata.annotations.chapter == "5") {
    allowed = true;
  }

  var admissionResponse = {
    allowed: allowed
  };

  for (var container of object.spec.containers) {
    console.log(container.securityContext);
    var image = container.image;
        var admissionReview = {
          response: admissionResponse
        };
        console.log("Response: " + JSON.stringify(admissionReview));
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(admissionReview));
        res.status(200).end();
    };
};

module.exports = {
  webhook: function (req, res) {
    webhook(req, res);
  }
}
