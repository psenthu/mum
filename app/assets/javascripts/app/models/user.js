App.User = Ember.Resource.extend({
  resourceUrl: '/users',
  resourceName: 'user',
  resourceProperties: ['first_name', 'last_name'],

  fullName: Ember.computed(function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  }).property('first_name', 'last_name')
});