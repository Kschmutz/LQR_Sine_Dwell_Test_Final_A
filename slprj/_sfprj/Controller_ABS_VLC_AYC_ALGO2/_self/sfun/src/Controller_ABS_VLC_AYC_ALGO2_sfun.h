#ifndef __Controller_ABS_VLC_AYC_ALGO2_sfun_h__
#define __Controller_ABS_VLC_AYC_ALGO2_sfun_h__

/* Include files */
#define S_FUNCTION_NAME                sf_sfun
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "sf_runtime/sf_runtime_errors.h"
#include "rtwtypes.h"
#include "simtarget/slClientServerAPIBridge.h"
#include "sf_runtime/sfc_sdi.h"
#include "sf_runtime/sf_test_language.h"
#include "multiword_types.h"
#include "sf_runtime/sfc_messages.h"
#include "sf_runtime/sfcdebug.h"
#define rtInf                          (mxGetInf())
#define rtMinusInf                     (-(mxGetInf()))
#define rtNaN                          (mxGetNaN())
#define rtIsNaN(X)                     ((int)mxIsNaN(X))
#define rtIsInf(X)                     ((int)mxIsInf(X))

struct SfDebugInstanceStruct;
extern struct SfDebugInstanceStruct* sfGlobalDebugInstanceStruct;

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */
extern uint32_T _Controller_ABS_VLC_AYC_ALGO2MachineNumber_;

/* Variable Definitions */

/* Function Declarations */
extern void Controller_ABS_VLC_AYC_ALGO2_initializer(void);
extern void Controller_ABS_VLC_AYC_ALGO2_terminator(void);

/* Function Definitions */

/* We load infoStruct for rtw_optimation_info on demand in mdlSetWorkWidths and
   free it immediately in mdlStart. Given that this is machine-wide as
   opposed to chart specific, we use NULL check to make sure it gets loaded
   and unloaded once per machine even though the  methods mdlSetWorkWidths/mdlStart
   are chart/instance specific. The following methods abstract this out. */
extern mxArray* load_Controller_ABS_VLC_AYC_ALGO2_optimization_info(boolean_T
  isRtwGen, boolean_T isModelRef, boolean_T isExternal);
extern void unload_Controller_ABS_VLC_AYC_ALGO2_optimization_info(void);

#endif
