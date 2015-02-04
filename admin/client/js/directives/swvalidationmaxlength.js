/**
 * Returns true if the user value is greater than the max length.
 * @module swvalidation
 * @class swValidationMaxLength
 */
angular.module('slatwalladmin').directive("swvalidationmaxlength", function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationmaxlength = 
            	function(modelValue, viewValue) {

        			//console.log(viewValue + " type:" + typeof(viewValue));
        				var constraintValue = attributes.swvalidationmaxlength;
        				var userValue = viewValue || 0;
        				if (parseInt(viewValue.length) >= parseInt(constraintValue))
        				{
        					return true;
        				}
        			return false;
        			
        		}
        }
    };
});