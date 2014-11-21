<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

--->
<cfparam name="rc.entities" />

<cfcontent type="text/javascript">
<cfset local.jsOutput = "" />
<cfsavecontent variable="local.jsOutput">
	<cfoutput>
		angular.module('ngSlatwall',[])
		.provider('$slatwall',[
		function(){
			var _deferred = {};
			
			var _config = {
				dateFormat : 'MM/DD/YYYY',
				timeFormat : 'HH:MM',
				rbLocale : '#request.slatwallScope.getRBLocal()#',
				baseURL : '/',
				applicationKey : 'Slatwall',
				debugFlag : #request.slatwallScope.getApplicationValue('debugFlag')#
			};
			
			if(slatwallConfig){
				angular.extend(_config,slatwallConfig);
			}
			
			return {
				
			    $get:['$q','$http','$log', function ($q,$http,$log)
			    {
			    	var slatwallService = {
			    		//basic entity getter where id is optional, returns a promise
				  		getDefer:function(deferKey){
				  			return _deferred[deferKey];
				  		},
				  		cancelPromise:function(deferKey){
				  			var deferred = this.getDefer(deferKey);
				  			if(angular.isDefined(deferred)){
				  				deferred.resolve({messages:[{messageType:'error',message:'User Cancelled'}]});
				  			}
				  		},
				      	newEntity:function(entityName){
				      		return new _jsEntities[entityName];
				      	},
				      	
				      	//basic entity getter where id is optional, returns a promise
				  		getEntity:function(entityName, options){
				  			/*
				  			 *
				  			 * getEntity('Product', '12345-12345-12345-12345');
				  			 * getEntity('Product', {keywords='Hello'});
				  			 * 
				  			 */
				  			if(angular.isDefined(options.deferKey)){
			    	  			this.cancelPromise(options.deferKey);
			    	  		}
			    	  		
				  			var params = {};
				  			if(typeof options === 'String') {
				  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName+'&entityID='+options.id;
				  			} else {
				  				params['P:Current'] = options.currentPage || 1;
				  				params['P:Show'] = options.pageShow || 10;
				  				params.keywords = options.keywords || '';
				  				params.columnsConfig = options.columnsConfig || '';
				  				params.filterGroupsConfig = options.filterGroupsConfig || '';
				  				params.joinsConfig = options.joinsConfig || '';
				  				params.isDistinct = options.isDistinct || false;
				  				params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  				params.allRecords = options.allRecords || '';
				  				params.defaultColumns = options.defaultColumns || true;
				  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName;
				  			}
				  			
				  			var deferred = $q.defer();
				  			if(angular.isDefined(options.id)) {
				  				urlString += '&entityId='+options.id;	
				  			}
				  			
				  			$http.get(urlString,{params:params,timeout:deferred.promise})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			if(options.deferKey){
				  				_deferred[options.deferKey] = deferred;
				  			}
				  			return deferred.promise;
				  			
				  		},
				  		getEventOptions:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getValidation:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getValidation&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getPropertyDisplayData:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName='+entityName;
				  			var params = {};
				  			params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getPropertyDisplayOptions:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName='+entityName;
				  			var params = {};
				  			params.property = options.property || '';
				  			if(angular.isDefined(options.argument1)){
				  				params.argument1 = options.argument1;
				  			}
				  			
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		saveEntity:function(entityName,id,params,context){
				  			$log.debug('save'+ entityName);
				  			var deferred = $q.defer();
			
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.post';	
				  			
				  			if(angular.isDefined(entityName)){
				  				params.entityName = entityName;
				  			}
				  			if(angular.isDefined(id)){
				  				params.entityID = id;
				  			}
			
				  			if(angular.isDefined(context)){
				  				params.context = context;
				  			}
				  			
				  			
				  			$http({
				  				url:urlString,
				  				method:'POST',
				  				data: $.param(params),
				  				headers: {'Content-Type': 'application/x-www-form-urlencoded'}
				  			})
				  			.success(function(data){
				  				deferred.resolve(data);
				  				
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		getExistingCollectionsByBaseEntity:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  			
				  		},
				  		getFilterPropertiesByBaseEntityName:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		loadResourceBundle:function(locale){
				  			var deferred = $q.defer();
				  			$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[locale] = response.data;
				  				deferred.resolve(response);
				  				
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		getResourceBundle:function(locale){
				  			var locale = locale || _config.rbLocale;
				  			
			  				if(_resourceBundle[locale]){
			  					return _resourceBundle[locale];
			  				}
			  				
			  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle'
				  			var params = {
				  				locale:locale,
				  			};
			  				$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[locale] = response.data;
			  				});
			  					
				  		},
						
				  		<!---replaceStringTemplate:function(template,object,formatValues,removeMissingKeys){
				  			/*formatValues = formatValues || false;
				  			removeMissingKeys = removeMissingKeys || false;
				  			//var res = str.replace(/microsoft/i, "W3Schools");
				  			var templateKeys = template.replace(\${[^}]+},);
				  			var replacementArray = [];
				  			var returnString = template;
				  			
				  			for(var i=0; i > templateKeys.length;i++){
				  				
				  			}*/
				  		}--->
				  		rbKey:function(key,replaceStringData){
				  			var keyValue = this.getRBKey(key,_config.locale);
				  			<!---if(angular.isDefined(replaceStringData) && ('"${'.toLowerCase().indexOf(keyValue))){
				  				keyValue = slatwallService.replaceStringTemplate(keyValue,replaceStringData);
				  			}--->
				  			return keyValue;
				  		},
				  		getRBKey:function(key,locale,checkedKeys,originalKey){
				  			checkedKeys = checkedKeys || "";
				  			locale = locale || 'en_us';
				  			
				  			<!---// Check to see if a list was passed in as the key--->
				  			var keyListArray = key.split(',');
				  			
							if(keyListArray.length > 1) {
								
								<!---// Set up "" as the key value to be passed as 'checkedKeys'--->
								var keyValue = "";
								
								<!---// If there was a list then try to get the key for each item in order--->
								for(var i=0; i<keyListArray.length; i++) {
									
									<!---// Get the keyValue from this iteration--->
									var keyValue = this.getRBKey(keyListArray[i], locale, keyValue);
									
									<!---// If the keyValue was found, then we can break out of the loop--->
									if(keyValue.slice(-8) != "_missing") {
										break;
									}
								}
								
								return keyValue;
							}
							
							<!---// Check the exact bundle file--->
							var bundle = slatwallService.getResourceBundle(locale);
							if(angular.isDefined(bundle[key])) {
								return bundle[key];
							}
							
							<!---// Because the value was not found, we can add this to the checkedKeys, and setup the original Key--->
							var checkedKeysListArray = checkedKeys.split(',');
							checkedKeysListArray.push(key+'_'+locale+'_missing');
							checkedKeys = checkedKeysListArray.join(",");
							if(angular.isUndefined(originalKey)){
								originalKey = key;
							}
							<!---// Check the broader bundle file--->
							var localeListArray = locale.split('_');
							if(localeListArray.length === 2){
								bundle = slatwallService.getResourceBundle(localeListArray[0]);
								if(angular.isDefined(bundle[key])){
									return bundle[key];
								}
								<!---// Add this more broad term to the checked keys--->
								checkedKeysListArray.push(key+'_'+localeListArray[0]+'_missing');
								checkedKeys = checkedKeysListArray.join(",");
							}
							<!---// Recursivly step the key back with the word 'define' replacing the previous.  Basically Look for just the "xxx.yyy.define.zzz" version of the end key and then "yyy.define.zzz" and then "define.zzz"--->
							var keyDotListArray = key.split('.');
							if(	keyDotListArray.length >= 3
								&& keyDotListArray[keyDotListArray.length - 2] === 'define'
							){
								var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3]+'.define','define');
								return this.getRBKey(newKey,locale,checkedKeys,originalKey);
							}else if( keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define'){
								var newKey = key.replace(keyDotListArray[keyDotListArray.length -2]+'.','define.');
								return this.getRBKey(newKey,locale,checkedKeys,originalKey);
							}
							if(localeListArray[0] !== "en"){
								
								return this.getRBKey(originalKey,'en',checkedKeys);
							}
				  			return checkedKeys;
				  		},
				  		 getConfig:function(){
					    	return _config;
					    },
					    getConfigValue:function(key){
					    	return _config[key];
					    },
					    setConfigValue:function(key,value){
					    	_config[key] = value;
					    },
					    setConfig:function(config){
					    	_config = config;
					    }
				      };
				  			 
			    	var _resourceBundle = {};
			    	var _jsEntities = {};
			    	
			    	var _init = function(entityInstance,data){
						for(var key in data) {
							if(key.charAt(0) !== '$'){
								entityInstance.data[key] = data[key];
							}
						}
					}
			    	
			    	var _getPropertyTitle = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
									
						if(angular.isDefined(propertyMetaData['hb_rbkey'])){
							return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
						}else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
							if(angular.isDefined(propertyMetaData['fieldtype']) 
							&& angular.isDefined(propertyMetaData['cfc'])
							&& ["one-to-many","many-to-many"].indexOf(propertyMetaData.fieldtype) > -1){
								
								return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+"."+propertyName+',entity.'+propertyMetaData.cfc+'_plural');
							}else if(angular.isDefined(propertyMetaData.fieldtype)
							&& angular.isDefined(propertyMetaData.cfc)
							&& ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
								return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc);
							}
							return metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
						}
						return metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
			    	}
			    	
			    	var _getPropertyHint = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		var keyValue = '';
			    		if(angular.isDefined(propertyMetaData['hb_rbkey'])){
							keyValue = metaData.$$getRBKey(propertyMetaData['hb_rbkey']+'_hint');
						}else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
							keyValue = metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+'_hint');
						}else{
							keyValue = metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
						}
						if(keyValue.slice(-8) !== '_missing'){
							return keyValue;
						}
						return '';
			    	}
			    	
			    	<!---var _getPropertyFieldName = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		if(angular.isDefined(propertyMetaData.fieldtype)
						&& angular.isDefined(propertyMetaData.cfc)
						&& ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
							
						}
			    	}--->
			    	
			    	var _getPropertyFieldType = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
						if(angular.isDefined(propertyMetaData['hb_formfieldtype'])){
							return propertyMetaData['hb_formfieldtype'];
						}
						
						if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
							var dataType = "";
							
							if(angular.isDefined(propertyMetaData.ormtype)){
								dataType = propertyMetaData.ormtype;
							}else if (angular.isDefined(propertyMetaData.type)){
								dataType = propertyMetaData.type;
							}
							if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
								return "yesno";
							}else if (["date","timestamp"].indexOf(dataType) > -1){
								return "dateTime";
							}else if ("array" === dataType){
								return "select";
							}else if ("struct" === dataType){
								return "checkboxgroup";
							}
							if(propertyName === 'password'){
								return "password";
							}
						}else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-one'){
							return 'select';
						}else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'one-to-many'){
							return 'There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldtype for '+propertyName;
						}else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-many'){
							return "listingMultiselect";
						}
					
			    		return "text";
			    	}
			    	
			    	var _getPropertyFormatType = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		
			    		if(angular.isDefined(propertyMetaData['hb_formattype'])){
			    			return propertyMetaData['hb_formattype'];
			    		}else if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
			    			var dataType = "";
							
							if(angular.isDefined(propertyMetaData.ormtype)){
								dataType = propertyMetaData.ormtype;
							}else if (angular.isDefined(propertyMetaData.type)){
								dataType = propertyMetaData.type;
							}
							
							if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
								return "yesno";
							}else if (["date","timestamp"].indexOf(dataType) > -1){
								return "dateTime";
							}else if (["big_decimal"].indexOf(dataType) > -1 && propertyName.slice(-6) === 'weight'){
								return "weight";
							}else if (["big_decimal"].indexOf(dataType) > -1){
								return "currency";
							}
			    		}
			    		return 'none';
			    	}
			    	
			    	var _isSimpleValue = function(value){
			    		<!---string, number, Boolean, or date/time value; False --->
			    		if(	
			    			angular.isString(value) || angular.isNumber(value) 
			    			|| angular.isDate(value) || value === false || value === true
			    		){
			    			return true;
			    		}else{
			    			return false;
			    		}
			    	}
			    	
			    	var utilityService = {
			    		formatValue:function(value,formatType,formatDetails,entityInstance){
			    			if(angular.isUndefined(formatDetails)){
			    				formatDetails = {};
			    			}
							var typeList = ["currency","date","datetime","pixels","percentage","second","time","truefalse","url","weight","yesno"];
							
							if(typeList.indexOf(formatType)){
								utilityService['format_'+formatType](value,formatDetails,entityInstance);
							}
							return value;
			    		},
			    		format_currency:function(value,formatDetails,entityInstance){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_date:function(value,formatDetails,entityInstance){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_datetime:function(value,formatDetails,entityInstance){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_pixels:function(value,formatDetails,entityInstance){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_yesno:function(value,formatDetails,entityInstance){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
							if(Boolean(value) === true ){
								return entityInstance.metaData.$$getRBKey("define.yes");
							}else if(value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0'){
								return entityInstance.metaData.$$getRBKey("define.no");
							}
			    		}
			    	}
			    	
			    	var _getFormattedValue = function(propertyName,formatType,entityInstance){
			    		var value = entityInstance.$$getPropertyByName(propertyName);
			    		
			    		if(angular.isUndefined(formatType)){
			    			formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
			    		}
			    		
			    		if(formatType === "custom"){
			    			return entityInstance['$$get'+propertyName+Formatted]();
			    		}else if(formatType === "rbkey"){
			    			if(angular.isDefined(value)){
			    				return entityInstance.$$getRBKey('entity.'+entityInstance.metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+'.'+value);
			    			}else{
			    				return '';
			    			}
			    		}
			    		if(angular.isUndefined(value)){
			    			var propertyMeta = entityInstance.metaData[propertyName];
			    			if(angular.isDefined(propertyMeta['hb_nullRBKey'])){
			    				return entityInstance.$$getRbKey(propertyMeta['hb_nullRBKey']);
			    			}
			    			
			    			return "";
			    		}else if (_isSimpleValue(value)){
			    			var formatDetails = {};
			    			if(angular.isDefined(entityInstance.data['currencyCode'])){
			    				formatDetails.currencyCode = entityInstance.$$getCurrencyCode();
			    			}
			    			//formatValue:function(value,formatType,formatDetails){
			    			
			    			return utilityService.formatValue(value,formatType,formatDetails,entityInstance);
			    		}
			    	}
			    	
			    	var _delete = function(entityInstance){
			    		console.log('delete');
			    		var entityName = entityInstance.metaData.className;
			    		var entityID = entityInstance.$$getID();
			    		var context = 'delete';
			    		var deletePromise = slatwallService.saveEntity(entityName,entityID,{},context);
			    		return deletePromise;
			    	}
			    	
			    	var _setValueByPropertyPath = function (obj,is, value) {
					    if (typeof is == 'string')
					        return _setValueByPropertyPath(obj,is.split('.'), value);
					    else if (is.length==1 && value!==undefined)
					        return obj[is[0]] = value;
					    else if (is.length==0)
					        return obj;
					    else
					        return _setValueByPropertyPath(obj[is[0]],is.slice(1), value);
					}
			    	
			    	
			    	var _addReturnedIDs = function(returnedIDs,entityInstance){
			    		entityInstance.data.workflowTask.data.workflowTaskID = 'test';
			    		for(var key in returnedIDs){
			    			var returnedIDPathArray = key.split('.');
			    			var ID = returnedIDs[key]; 
			    			var keyString = key.replace(/\./g,'.data.');
			    			_setValueByPropertyPath(entityInstance,'data.'+keyString,String(ID));
			    		}
			    		
			    	}
			    	
			    	var _save = function(entityInstance){
			    		console.log('save');
			    		console.log(entityInstance);
			    		
			    		var entityName = entityInstance.metaData.className;
			    		var entityID = entityInstance.$$getID();
			    		
			    		var modifiedData = _getModifiedData(entityInstance);
			    		
			    		var params = modifiedData;
			    		<!---figure out what IDs to return for persisted data --->
			    		var propertyIdentifiersArray = [];
			    		for(var key in params){
			    			if(key.slice(-2) === 'ID'){
			    				if(params[key] === ''){
			    					propertyIdentifiersArray.push(key);
			    				}
			    			}
			    		}
			    		params.propertyIdentifiersList = propertyIdentifiersArray.join(",") || '';
			    		var context = 'save';
			    		<!---validate based on context --->
			    		<!---probably need to validat against data to make sure existing data passes and then against modified? --->
			    		
			    		var savePromise = slatwallService.saveEntity(entityName,entityID,params,context);
			    		savePromise.then(function(response){
			    			var returnedIDs = response.data;
			    			<!--- TODO: restet form --->
							//entityInstance.form.$setPristine();
							_addReturnedIDs(returnedIDs,entityInstance);
						});
						return savePromise;
			    	}
			    	
			    	var _getModifiedData = function(entityInstance){
			    		var modifiedData = {};
			    		
			    		modifiedData = getModifiedDataByInstance(entityInstance);
			    		
			    		return modifiedData;
			    	}
			    	
			    	var getModifiedDataByInstance = function(entityInstance,parentPath){
			    		var modifiedData = {};
			    		var forms = entityInstance.forms;
			    		if(angular.isUndefined(parentPath)){
			    			parentPath = '';
			    			modifiedData[entityInstance.$$getIDName()] = entityInstance.$$getID();
			    		}
			    		for(var f in forms){
			    			var form = forms[f];
				    		for(var key in form){
				    			if(key.charAt(0) !== '$'){
				    				var inputField = form[key];
				    				if(inputField.$valid === true && inputField.$dirty === true){
			    						modifiedData[key] = form[key].$modelValue;
				    				}
				    			}
				    		}
			    		}
			    		
			    		var entityID = entityInstance.$$getID();	
			    		
			    		if(entityID === ""){
			    			<!---/*check if the object has a parent*/--->
			    			if(angular.isDefined(entityInstance.data[entityInstance.parentObject])){
			    				<!---get parent instance --->
			    				
			    				var parentEntityInstance = entityInstance.data[entityInstance.parentObject];
			    				parentPath = entityInstance.parentObject+'.'+parentPath;
			    				var parentModifiedData = getModifiedDataByInstance(parentEntityInstance,parentPath);
			    				for(var p in parentModifiedData){
			    					modifiedData[entityInstance.parentObject+'.'+p] = parentModifiedData[p];
			    				}
			    				//var parentEntityInstanceName = parentEntityInstance.metaData.className;
			    				//var parentEntityInstanceID = parentEntityInstance.$$getID();
			    				modifiedData[entityInstance.parentObject+'.'+parentEntityInstance.$$getIDName()] =  parentEntityInstance.$$getID();
			    			}
			    		}
			    		
			    		return modifiedData;
			    	}
			    	
			    	var _getValidationsByProperty = function(entityInstance,property){
			    		return entityInstance.validations.properties[property];
			    	}
			    	
			    	var _getValidationByPropertyAndContext = function(entityInstance,property,context){
			    		var validations = _getValidationsByProperty(entityInstance,property);
			    		for(var i in validations){
			    			<!---get list of contexts for this validation --->
			    			var contexts = validations[i].contexts.split(',');
			    			for(var j in contexts){
			    				if(contexts[j] === context){
				    				return validations[i];
				    			}
			    			}
			    			
			    		}
			    	}
			    	<!--- js entity specific code here --->
					<cfinclude template="ngslatwallentities.cfm" >
					
				
		      return slatwallService;
	       }],
		    setJsEntities: function(jsEntities){
		    	_jsEntities=jsEntities;
		    },
		    getJsEntities: function(){
		    	return _jsEntities;
		    },
		    getConfig:function(){
		    	return _config;
		    },
		    getConfigValue:function(key){
		    	return _config[key];
		    },
		    setConfigValue:function(key,value){
		    	_config[key] = value;
		    },
		    setConfig:function(config){
		    	_config = config;
		    }
		};
		}]).config(function ($slatwallProvider) {
			/* $slatwallProvider.setConfigValue($.slatwall.getConfig().baseURL); */
		}).run(function($slatwall){
			var localeListArray = $slatwall.getConfigValue('rbLocale').split('_');
			$slatwall.getResourceBundle($slatwall.getConfigValue('rbLocale'));
			if(localeListArray.length === 2){
				$slatwall.getResourceBundle(localeListArray[0]);
			}
			if(localeListArray[0] != 'en'){
				$slatwall.getResourceBundle('en_us');
				$slatwall.getResourceBundle('en');
			}	
		});
	</cfoutput>
</cfsavecontent>

<cfif request.slatwallScope.getApplicationValue('debugFlag')>
	<cfset getPageContext().getOut().clearBuffer() />
	<cfoutput>#local.jsOutput#</cfoutput>	
<cfelse>
	<!---
	<cfset local.oYUICompressor = createObject("component", "Slatwall.org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'Slatwall.org.Hibachi.YUIcompressor.javaloader.JavaLoader', libPath = expandPath('/Slatwall/org/Hibachi/YUIcompressor/lib')) />
	<cfset local.jsOutputCompressed = oYUICompressor.compress(
												inputType = 'js'
												,inputString = local.jsOutput
												) />
												
	<cfoutput>#local.jsOutputCompressed#</cfoutput>
	--->
	<cfset getPageContext().getOut().clearBuffer() />
	<cfoutput>#local.jsOutput#</cfoutput>
</cfif>
