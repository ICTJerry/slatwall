/**
 *  Validates true if the user value != the property value.
 *  @module swvalidation
 *  @class swValidationNEQ
 */
angular.module('slatwalladmin').directive("swvalidationneq", function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationneq = 
            	function(modelValue) {
        		 	if (modelValue != attributes.swvalidationneq){return true;}
        			return false;
            }
        }
    };
});