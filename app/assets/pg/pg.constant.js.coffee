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
        'Private sector professional'
        'Civil servant'
        'Farmer'
        'Journalist, public relations'
        'Lawyer'
        'Manual worker, craftsman/woman'
        'Medical doctor, dentist, optician'
        'Miner'
        'Teacher'
        'University professor'
        'Student'
        'No occupation'
        'Other'
      ]
    POLITICAL_LEANINGS:
      [
        'Left wing'
        'Center-left (social democrat)'
        'Green'
        'Center (liberal)'
        'Conservative'
        'Far-right'
        'Other'
      ]
    ROUNDS:
      [
        {
          title: 'Round 1 out of 3'
          index: 1
          description: 'In this first round, you have to collect data on the gender of each of your representatives.'
        }
        {
          title: 'Round 2 out of 3'
          index: 2
          description: 'In this round, you have to find <strong>at least one</strong> piece of information for each representative.'
        }
        {
          title: 'Round 3 out of 3'
          index: 3
          description: 'In this last round, you have to judge which representative fits most the stereotype of a politician.'
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
