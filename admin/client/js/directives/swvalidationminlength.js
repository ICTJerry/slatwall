/**
 * Returns true if the user value is greater than the min length.
 * @module swvalidation
 * @class swValidationMinLength
 */
angular.module('slatwalladmin').directive("swvalidationminlength", function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationminlength = 
            	function(modelValue, viewValue) {

        			//console.log(viewValue + " type:" + typeof(viewValue));
        				var constraintValue = attributes.swvalidationminlength;
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