import mandatureFormDirective from './components/mandature-form/mandature-form.directive.js.coffee';
import mandatureFormController from './components/mandature-form/mandature-form.controller.js.coffee';

import pgRoundState from './pg/level/round/round.state.js.coffee';
import pgDiversityState from './pg/level/round/diversity/diversity.state.js.coffee';
import pgDiversityController from './pg/level/round/diversity/diversity.controller.js.coffee';
import pgRoundController from './pg/level/round/round.controller.js.coffee';
import pgDetailsState from './pg/level/round/details/details.state.js.coffee';
import pgDetailsController from './pg/level/round/details/details.controller.js.coffee';
import pgSummaryState from './pg/level/round/details/summary/summary.state.js.coffee';
import pgSummaryController from './pg/level/round/details/summary/summary.controller.js.coffee';
import pgIntroState from './pg/level/round/intro/intro.state.js.coffee';
import pgIntroController from './pg/level/round/intro/intro.controller.js.coffee';
import pgGenderState from './pg/level/round/gender/gender.state.js.coffee';
import pgGenderController from './pg/level/round/gender/gender.controller.js.coffee';
import pgSummaryState from './pg/level/round/gender/summary/summary.state.js.coffee';
import pgSummaryController from './pg/level/round/gender/summary/summary.controller.js.coffee';
import pgLevelController from './pg/level/level.controller.js.coffee';
import pgLevelState from './pg/level/level.state.js.coffee';
import pgPgController from './pg/pg.controller.js.coffee';
import pgDataState from './pg/data/data.state.js.coffee';
import pgDataController from './pg/data/data.controller.js.coffee';
import pgPgModule from './pg/pg.module.js.coffee';
import pgEditController from './pg/representatives/edit/edit.controller.js.coffee';
import pgEditState from './pg/representatives/edit/edit.state.js.coffee';
import pgRepresentativesController from './pg/representatives/representatives.controller.js.coffee';
import pgRepresentativesState from './pg/representatives/representatives.state.js.coffee';
import pgState from './pg/pg.state.js.coffee';
import pgIntroState from './pg/intro/intro.state.js.coffee';
import pgIntroController from './pg/intro/intro.controller.js.coffee';
import pgIntroConstant from './pg/intro/intro.constant.js.coffee';
import pgConstant from './pg/pg.constant.js.coffee';
import pgRun from './pg/pg.run.js.coffee';
import pg204State from './pg/204/204.state.js.coffee';


angular
  .module('jquest')
  .directive(mandatureFormDirective)
  .controller(mandatureFormController)
  .controller(pgDiversityController)
  .controller(pgRoundController)
  .controller(pgDetailsController)
  .controller(pgSummaryController)
  .controller(pgIntroController)
  .controller(pgGenderController)
  .controller(pgSummaryController)
  .controller(pgLevelController)
  .controller(pgPgController)
  .controller(pgDataController)
  .controller(pgEditController)
  .controller(pgRepresentativesController)
  .controller(pgIntroController)
  .config(pgRoundState)
  .config(pgDiversityState)
  .config(pgDetailsState)
  .config(pgSummaryState)
  .config(pgIntroState)
  .config(pgGenderState)
  .config(pgSummaryState)
  .config(pgLevelState)
  .config(pgDataState)
  .config(pgEditState)
  .config(pgRepresentativesState)
  .config(pgState)
  .config(pgIntroState)
  .config(pg204State)
  .constant(pgIntroConstant)
  .constant(pgConstant)
  .run(pgRun)
