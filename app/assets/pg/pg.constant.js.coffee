angular.module 'jquest'
  .constant 'SETTINGS',
    CATEGORIES:
      [
        'Parliaments of {{ country_name }}'
        'Parliaments of foreign countries'
        'Historical parliaments'
      ]
    PROFESSION_CATEGORIES:
      [
        'Armed forces'
        'Businessman/woman'
        'Civil servant'
        'Farmer'
        'Journalist, public relations'
        'Lawyer'
        'Manual worker, craftsman/woman'
        'Medical doctor, dentist, optician '
        'Miner'
        'Teacher'
        'University professor'
        'Student'
        'No occupation'
        'Other'
      ]
    POLITICAL_LEANINGS:
      [
        'Communist'
        'Left (non-communist)'
        'Center-left (social democrat)'
        'Green'
        'Liberal'
        'Conservative'
        'Nationalist'
        'Regionalist'
        'Other'
      ]
    LEVELS:
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
