import mandatureFormDirective from './components/mandature-form/mandature-form.directive.coffee';
import mandatureFormController from './components/mandature-form/mandature-form.controller.coffee';

import pgController from './pg/pg.controller.coffee';

import pgIntroState from './pg/intro/intro.state.coffee';
import pgIntroConstant from './pg/intro/intro.constant.coffee';
import pgIntroController from './pg/intro/intro.controller.coffee';

import pgLevelState from './pg/level/level.state.coffee';
import pgLevelController from './pg/level/level.controller.coffee';

import pgLevelRoundState from './pg/level/round/round.state.coffee';
import pgLevelRoundController from './pg/level/round/round.controller.coffee';

import pgLevelRoundIntroState from './pg/level/round/intro/intro.state.coffee';
import pgLevelRoundIntroController from './pg/level/round/intro/intro.controller.coffee';

import pgLevelRoundGenderState from './pg/level/round/gender/gender.state.coffee';
import pgLevelRoundGenderController from './pg/level/round/gender/gender.controller.coffee';
import pgLevelRoundGenderSummaryState from './pg/level/round/gender/summary/summary.state.coffee';
import pgLevelRoundGenderSummaryController from './pg/level/round/gender/summary/summary.controller.coffee';

import pgLevelRoundDetailsState from './pg/level/round/details/details.state.coffee';
import pgLevelRoundDetailsController from './pg/level/round/details/details.controller.coffee';
import pgLevelRoundDetailsSummaryState from './pg/level/round/details/summary/summary.state.coffee';
import pgLevelRoundDetailsSummaryController from './pg/level/round/details/summary/summary.controller.coffee';

import pgLevelRoundDiversityState from './pg/level/round/diversity/diversity.state.coffee';
import pgLevelRoundDiversityController from './pg/level/round/diversity/diversity.controller.coffee';


import pgDataState from './pg/data/data.state.coffee';
import pgDataController from './pg/data/data.controller.coffee';

import pgRepresentativesEditController from './pg/representatives/edit/edit.controller.coffee';
import pgRepresentativesEditState from './pg/representatives/edit/edit.state.coffee';

import pgRepresentativesController from './pg/representatives/representatives.controller.coffee';
import pgRepresentativesState from './pg/representatives/representatives.state.coffee';

import pgState from './pg/pg.state.coffee';
import pgConstant from './pg/pg.constant.coffee';
import pgRun from './pg/pg.run.coffee';
import pg204State from './pg/204/204.state.coffee';

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
