/**
 * SwValidationGTE: Validates true if the user value >= to the constraint value.
 * @module swvalidation
 * @class swValidationGTE
 * @example 
 * 		<input type='text' swvalidationgte='5' /> will validate false if the user enters
 * 		value less than OR equal to 5.
 */

angular.module('slatwalladmin').directive("swvalidationgte", function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationgte = 
            	function(modelValue, viewValue) {
        			var constraintValue = attributes.swvalidationgte || 0;
        			console.log(viewValue);
        		 	if (parseInt(modelValue) >= parseInt(constraintValue))
        		 	{
        		 		return true; //Passes the validation
        		 	}
    				return false;
    				
            }//<--end function
        }//<--end link
    };
});
