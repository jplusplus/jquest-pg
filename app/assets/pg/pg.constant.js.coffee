angular.module 'jquest'
  .constant 'CATEGORIES',
    [
      'Parliaments of {{ country_name }}'
      'Parliaments of foreign countries'
      'Historical parliaments'
    ]
  .constant 'LEVELS',
    [
      {
        title: 'Level 1'
        description: 'Lorem ipsum dolor sit description'
        category: 0
      }
      {
        title: 'Level 2'
        description: 'Lorem ipsum dolor sit description'
        category: 0
      }
      {
        title: 'Level 3'
        description: 'Lorem ipsum dolor sit description'
        category: 0
      }
      {
        title: 'Level 4'
        description: 'Lorem ipsum dolor sit description'
        category: 1
      }
      {
        title: 'Level 5'
        description: 'Lorem ipsum dolor sit description'
        category: 1
      }
      {
        title: 'Level 6'
        description: 'Lorem ipsum dolor sit description'
        category: 2
      }
    ]
