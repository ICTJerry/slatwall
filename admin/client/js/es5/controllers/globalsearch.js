"use strict";
'use strict';
angular.module('slatwalladmin').controller('globalSearch', ['$scope', '$log', '$window', '$timeout', '$slatwall', function($scope, $log, $window, $timeout, $slatwall) {
  $scope.keywords = '';
  $scope.searchResultsOpen = false;
  $scope.sidebarClass = 'sidebar';
  $scope.loading = false;
  $scope.resultsFound = true;
  $scope.searchResults = {
    'product': {
      'title': 'Products',
      'resultNameFilter': function(data) {
        return data['productName'];
      },
      'results': [],
      'id': function(data) {
        return data['productID'];
      }
    },
    'brand': {
      'title': $slatwall.getRBKey('entity.Brands'),
      'resultNameFilter': function(data) {
        return data['brandName'];
      },
      'results': [],
      'id': function(data) {
        return data['brandID'];
      }
    },
    'account': {
      'title': 'Accounts',
      'resultNameFilter': function(data) {
        return data['firstName'] + ' ' + data['lastName'];
      },
      'results': [],
      'id': function(data) {
        return data['accountID'];
      }
    },
    'vendor': {
      'title': 'Vendors',
      'resultNameFilter': function(data) {
        return data['vendorName'];
      },
      'results': [],
      'id': function(data) {
        return data['vendorID'];
      }
    }
  };
  var _timeoutPromise;
  var _loadingCount = 0;
  $scope.updateSearchResults = function() {
    $scope.loading = true;
    $scope.showResults();
    if (_timeoutPromise) {
      $timeout.cancel(_timeoutPromise);
    }
    _timeoutPromise = $timeout(function() {
      if ($scope.keywords === '') {
        $scope.hideResults();
      } else {
        $scope.showResults();
        _loadingCount = Object.keys($scope.searchResults).length;
        for (var entityName in $scope.searchResults) {
          (function(entityName) {
            var searchPromise = $slatwall.getEntity(entityName, {
              keywords: $scope.keywords,
              pageShow: 4,
              deferkey: 'global-search-' + entityName
            });
            searchPromise.then(function(data) {
              $scope.searchResults[entityName].results = [];
              $scope.searchResults[entityName].title = $slatwall.getRBKey('entity.' + entityName.toLowerCase() + '_plural');
              for (var i in data.pageRecords) {
                $scope.searchResults[entityName].results.push({
                  'name': $scope.searchResults[entityName].resultNameFilter(data.pageRecords[i]),
                  'link': '?slatAction=entity.detail' + entityName + '&' + entityName + 'ID=' + $scope.searchResults[entityName].id(data.pageRecords[i])
                });
              }
              _loadingCount--;
              if (_loadingCount == 0) {
                $scope.loading = false;
                var _foundResults = false;
                for (var _thisEntityName in $scope.searchResults) {
                  if ($scope.searchResults[_thisEntityName].results.length) {
                    _foundResults = true;
                    break;
                  }
                }
                $scope.resultsFound = _foundResults;
              }
            });
          })(entityName);
        }
      }
    }, 500);
  };
  $scope.showResults = function() {
    $scope.searchResultsOpen = true;
    $scope.sidebarClass = 'sidebar s-search-width';
    $window.onclick = function(event) {
      var _targetClassOfSearch = event.target.parentElement.offsetParent.classList.contains('sidebar');
      if (!_targetClassOfSearch) {
        $scope.hideResults();
        $scope.$apply();
      }
    };
  };
  $scope.hideResults = function() {
    $scope.searchResultsOpen = false;
    $scope.sidebarClass = 'sidebar';
    $scope.search.$setPristine();
    $scope.keywords = "";
    $window.onclick = null;
    $scope.loading = false;
    $scope.resultsFound = true;
    for (var entityName in $scope.searchResults) {
      $scope.searchResults[entityName].results = [];
    }
  };
}]);

//# sourceMappingURL=../controllers/globalsearch.js.map