angular.module 'jquest'
  .constant 'SETTINGS',
    CATEGORIES:
      [
        'Parliaments of {{ home_country_name }}'
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
    ROUNDS:
      [
        {
          title: 'Round 1/3'
          index: 1
          description: 'In this first round, we ask you to indicate the gender for each of your representatives.'
        }
        {
          title: 'Round 2/3'
          index: 2
          description: 'In this round, we ask you to find at least one piece of information for each of your representatives.'
        }
        {
          title: 'Round 3/3'
          index: 3
          description: 'In this last round, we ask you to tell us how stereotypical is the outlook of your representatives.'
        }
      ]
    LEVELS:
      [
        {
          title: 'Level 1',
          index: 1,
          description: 'National parliament of your home country'
          category: 0
        }
        {
          title: 'Level 2',
          index: 2,
          description: 'Regional parliament of your home country'
          category: 0
        }
        {
          title: 'Level 3',
          index: 3,
          description: 'Local parliament of your home country'
          category: 0
        }
        {
          title: 'Level 4',
          index: 4,
          description: 'Foreign parliament'
          category: 1
        }
        {
          title: 'Level 5',
          index: 5,
          description: 'Very foreign parliament'
          category: 1
        }
        {
          title: 'Level 6',
          index: 6,
          description: 'Older parliament of home country'
          category: 2
        }
        {
          title: 'Level 7',
          index: 7,
          description: 'Historical parliament'
          category: 2
        }
      ]
