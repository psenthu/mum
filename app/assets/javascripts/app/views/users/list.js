App.ListUsersView = Ember.View.extend({
  templateName: 'app/templates/users/list',
  usersBinding: 'App.usersController',

  showNew: function() {
    this.set('isNewVisible', true);
  },

  hideName: function() {
    this.set('isNewVisible', false);
  },

  refreshListing: function() {
    App.usersController.findAll();
  }
});