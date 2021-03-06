/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
angular.module('slatwalladmin').directive("swvalidationunique", ['$http', '$q', '$slatwall', '$log', function ($http, $q, $slatwall, $log) {
    return {
        restrict: "A",
        require: "ngModel",
        link: function (scope, element, attributes, ngModel) {
            ngModel.$asyncValidators.swvalidationunique = function (modelValue, viewValue) {
                $log.debug('asyc');
                var deferred = $q.defer(), currentValue = modelValue || viewValue, key = scope.propertyDisplay.object.metaData.className, property = scope.propertyDisplay.property;
                //First time the asyncValidators function is loaded the
                //key won't be set  so ensure that we have 
                //key and propertyName before checking with the server 
                if (key && property) {
                    $slatwall.checkUniqueValue(key, property, currentValue).then(function (unique) {
                        $log.debug('uniquetest');
                        $log.debug(unique);
                        if (unique) {
                            deferred.resolve(); //It's unique
                        }
                        else {
                            deferred.reject(); //Add unique to $errors
                        }
                    });
                }
                else {
                    deferred.resolve(); //Ensure promise is resolved if we hit this 
                }
                return deferred.promise;
            };
        }
    };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationunique.js.map