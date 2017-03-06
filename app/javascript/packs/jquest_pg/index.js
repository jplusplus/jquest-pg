import mandatureFormDirective from './components/mandature-form/mandature-form.directive.js.coffee';
import mandatureFormController from './components/mandature-form/mandature-form.controller.js.coffee';

import pgController from './pg/pg.controller.js.coffee';

import pgIntroState from './pg/intro/intro.state.js.coffee';
import pgIntroConstant from './pg/intro/intro.constant.js.coffee';
import pgIntroController from './pg/intro/intro.controller.js.coffee';

import pgLevelState from './pg/level/level.state.js.coffee';
import pgLevelController from './pg/level/level.controller.js.coffee';

import pgLevelRoundState from './pg/level/round/round.state.js.coffee';
import pgLevelRoundController from './pg/level/round/round.controller.js.coffee';

import pgLevelRoundIntroState from './pg/level/round/intro/intro.state.js.coffee';
import pgLevelRoundIntroController from './pg/level/round/intro/intro.controller.js.coffee';

import pgLevelRoundGenderState from './pg/level/round/gender/gender.state.js.coffee';
import pgLevelRoundGenderController from './pg/level/round/gender/gender.controller.js.coffee';
import pgLevelRoundGenderSummaryState from './pg/level/round/gender/summary/summary.state.js.coffee';
import pgLevelRoundGenderSummaryController from './pg/level/round/gender/summary/summary.controller.js.coffee';

import pgLevelRoundDetailsState from './pg/level/round/details/details.state.js.coffee';
import pgLevelRoundDetailsController from './pg/level/round/details/details.controller.js.coffee';
import pgLevelRoundDetailsSummaryState from './pg/level/round/details/summary/summary.state.js.coffee';
import pgLevelRoundDetailsSummaryController from './pg/level/round/details/summary/summary.controller.js.coffee';

import pgLevelRoundDiversityState from './pg/level/round/diversity/diversity.state.js.coffee';
import pgLevelRoundDiversityController from './pg/level/round/diversity/diversity.controller.js.coffee';


import pgDataState from './pg/data/data.state.js.coffee';
import pgDataController from './pg/data/data.controller.js.coffee';

import pgRepresentativesEditController from './pg/representatives/edit/edit.controller.js.coffee';
import pgRepresentativesEditState from './pg/representatives/edit/edit.state.js.coffee';

import pgRepresentativesController from './pg/representatives/representatives.controller.js.coffee';
import pgRepresentativesState from './pg/representatives/representatives.state.js.coffee';

import pgState from './pg/pg.state.js.coffee';
import pgConstant from './pg/pg.constant.js.coffee';
import pgRun from './pg/pg.run.js.coffee';
import pg204State from './pg/204/204.state.js.coffee';

import './index.scss';

angular
  .module('jquest')
  .directive('mandatureForm', mandatureFormDirective)
  .controller('MainSeasonPgCtrl', pgController)
  .controller('MainSeasonPgIntroCtrl', pgIntroController)
  .controller('MainSeasonPgLevelCtrl', pgLevelController)
  .controller('MainSeasonPgLevelRoundCtrl', pgLevelRoundController)
  .controller('MainSeasonPgLevelRoundIntroCtrl', pgLevelRoundIntroController)
  .controller('MainSeasonPgLevelRoundGenderCtrl', pgLevelRoundGenderController)
  .controller('MainSeasonPgLevelRoundGenderSummaryCtrl', pgLevelRoundGenderSummaryController)
  .controller('MainSeasonPgLevelRoundDetailsCtrl', pgLevelRoundDetailsController)
  .controller('MainSeasonPgLevelRoundDetailsSummaryCtrl', pgLevelRoundDetailsSummaryController)
  .controller('MainSeasonPgLevelRoundDiversityCtrl', pgLevelRoundDiversityController)
  .controller('MainSeasonPgDataCtrl', pgDataController)
  .controller('MainSeasonPgRepresentativesCtrl', pgRepresentativesController)
  .controller('MainSeasonPgRepresentativesEditCtrl', pgRepresentativesEditController)
  .controller('MandatureFormCtrl', mandatureFormController)
  .config(pgState)
  .config(pg204State)
  .config(pgIntroState)
  .config(pgLevelState)
  .config(pgLevelRoundState)
  .config(pgLevelRoundIntroState)
  .config(pgLevelRoundGenderState)
  .config(pgLevelRoundGenderSummaryState)
  .config(pgLevelRoundDetailsState)
  .config(pgLevelRoundDetailsSummaryState)
  .config(pgLevelRoundDiversityState)
  .config(pgDataState)
  .config(pgRepresentativesState)
  .config(pgRepresentativesEditState)
  .constant('INTRO', pgIntroConstant)
  .constant('SETTINGS', pgConstant)
  .run(pgRun)
