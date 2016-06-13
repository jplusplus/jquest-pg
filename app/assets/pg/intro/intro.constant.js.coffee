angular.module 'jquest'
  .constant 'INTRO',
    slides: [
      {
        type: 'text',
        body: 'Welcome to jQuest Season 1:<br /><span class="pg__intro__slide__body__big">Diversity in Parliament</span>'
      }
      {
        type: 'text'
        body: 'Together with 123 students from across Europe, you’ll do an exclusive data-driven investigation.'
      }
      {
        type: 'question'
        body: 'Do you think this person is member of Parliament?'
        image: 'http://placehold.it/200x300/6C99C0/fff'
      }
      {
        type: 'question'
        body: 'Do you think this person is member of Parliament?'
        image: 'http://placehold.it/200x300/e34d4d/fff'
      }
      {
        type: 'question'
        body: 'Do you think this person is member of Parliament?'
        image: 'http://placehold.it/200x300/6C99C0/fff'
      }
      {
        type: 'text'
        body: 'It was easy, right?<br />Because our parliaments, in Europe, are not as diverse as our society.'
      }
      {
        type: 'text'
        body: 'How much so? No one knows.<br />And that\'s what you\'re going to find out.'
      }
    ]
