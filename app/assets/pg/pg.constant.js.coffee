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
        description: 'National parliament of your home country'
        category: 0
      }
      {
        title: 'Level 2'
        description: 'Regional parliament of your home country'
        category: 0
      }
      {
        title: 'Level 3'
        description: 'Local parliament of your home country'
        category: 0
      }
      {
        title: 'Level 4'
        description: 'Foreign parliament'
        category: 1
      }
      {
        title: 'Level 5'
        description: 'Older parliament of home country'
        category: 1
      }
      {
        title: 'Level 6'
        description: 'Very foreign parliament'
        category: 1
      }
      {
        title: 'Level 7'
        description: 'Historical parliament'
        category: 2
      }
    ]
