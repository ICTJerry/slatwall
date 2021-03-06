"use strict";
angular.module('slatwalladmin').directive('swOrderItemDetailStamp', ['partialsPath', '$log', '$slatwall', function(partialsPath, $log, $slatwall) {
  return {
    restrict: 'A',
    scope: {
      systemCode: "=",
      orderItemId: "=",
      skuId: "=",
      orderItem: "="
    },
    templateUrl: partialsPath + "orderitem-detaillabel.html",
    link: function(scope, element, attrs) {
      scope.details = [];
      scope.orderItem.detailsName = [];
      var results;
      $log.debug("Detail stamp");
      $log.debug(scope.systemCode);
      $log.debug(scope.orderItemId);
      $log.debug(scope.skuId);
      $log.debug(scope.orderItem);
      var getMerchandiseDetails = function(orderItem) {
        for (var i = 0; i <= orderItem.data.sku.data.options.length - 1; i++) {
          orderItem.details.push(orderItem.data.sku.data.options[i].optionCode);
          orderItem.details.push(orderItem.data.sku.data.options[i].optionName);
        }
      };
      var getSubscriptionDetails = function(orderItem) {
        var name = orderItem.data.sku.data.subscriptionTerm.data.subscriptionTermName || "";
        orderItem.detailsName.push("Subscription Term:");
        orderItem.details.push(name);
        for (var i = 0; i <= orderItem.data.sku.data.subscriptionBenefits.length - 1; i++) {
          var benefitName = orderItem.data.sku.data.subscriptionBenefits[i].subscriptionBenefitName || "";
          orderItem.detailsName.push("Subscription Benefit:");
          orderItem.details.push(benefitName);
        }
      };
      var getEventDetails = function(orderItem) {
        orderItem.detailsName.push("Event Date: ");
        orderItem.details.push(orderItem.data.sku.data.eventStartDateTime);
        for (var i = 0; i <= orderItem.data.sku.data.locations.length - 1; i++) {
          orderItem.detailsName.push("Location: ");
          orderItem.details.push(orderItem.data.sku.data.locations[i].locationName);
        }
      };
      if (angular.isDefined(scope.orderItem.details)) {
        switch (scope.systemCode) {
          case "merchandise":
            results = getMerchandiseDetails(scope.orderItem);
            break;
          case "subscription":
            results = getSubscriptionDetails(scope.orderItem);
            break;
          case "event":
            results = getEventDetails(scope.orderItem);
            break;
        }
        scope.orderItem.details.push(results);
      }
    }
  };
}]);

//# sourceMappingURL=../../directives/orderitem/sworderitemdetailstamp.js.map