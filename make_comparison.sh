#!/usr/bin/env -S bash -l
# Make some comparison figures, running operations in consistent manner


module load apptainer
conda activate flint_main

WSCLEAN_CONTAINER="/scratch3/gal16b/wsclean_scales.sif"
COMMON_WSCLEAN_OPTS="-multiscale -parallel-gridding 8 -size 6192 6192 -scale 2asec -pol i -nmiter 6 -mgain 0.9 -niter 100000 -auto-mask 5 -auto-threshold 3 -channels-out 8 -join-channels"

ORIGMS="scienceData.FLASH_759.SB84552.FLASH_759.beam21_averaged_cal.leakage.ms"
RAWMS="raw/${ORIGMS}"


# ---------------------------------------------------
# This is the original data imaging section
# ---------------------------------------------------
NOJR="NO_JR"
MS="${NOJR}/${ORIGMS}"

mkdir "${NOJR}"
echo "Copying to ${MS}"
cp -r "${RAWMS}" "${MS}"

fix_ms_dir "${MS}"

WSCLEAN_CMD="wsclean ${COMMON_WSCLEAN_OPTS} -data-column DATA -name ${NOJR}/no_jolly ${MS}"
apptainer exec $WSCLEAN_CONTAINER $WSCLEAN_CMD
# ---------------------------------------------------

COMMON_JR_OPTS="--reweight --make-plots --number-of-plots 34 --max-workers 12 --chunk-size 1000 --outer-width 30 --data-column DATA --output-column JOLLY_DATA --overwrite  --guard-field --guard-field-fraction 0.1"

# ---------------------------------------------------
# This is jolly-roger test 1
# ---------------------------------------------------
WJR0="W_JR_0"
MS="${WJR0}/${ORIGMS}"

mkdir "${WJR0}"
echo Copying to $MS
cp -r "${RAWMS}" "${MS}"

fix_ms_dir "$MS"

jolly_tractor \
    tukey \
    $COMMON_JR_OPTS \
    --ignore-nyquist-zone 1 \
    "${MS}"

WSCLEAN_CMD="wsclean ${COMMON_WSCLEAN_OPTS} -data-column JOLLY_DATA -name ${WJR1}/with_jolly0 ${MS}"
apptainer exec $WSCLEAN_CONTAINER $WSCLEAN_CMD
# ---------------------------------------------------


# ---------------------------------------------------
# This is jolly-roger test 1
# ---------------------------------------------------
WJR1="W_JR_1"
MS="${WJR1}/${ORIGMS}"

mkdir "${WJR1}"
echo Copying to $MS
cp -r "${RAWMS}" "${MS}"

fix_ms_dir "$MS"

jolly_tractor \
    tukey \
    $COMMON_JR_OPTS \
    --ignore-nyquist-zone 2 \
    "${MS}"

WSCLEAN_CMD="wsclean ${COMMON_WSCLEAN_OPTS} -data-column JOLLY_DATA -name ${WJR1}/with_jolly1 ${MS}"
apptainer exec $WSCLEAN_CONTAINER $WSCLEAN_CMD
# ---------------------------------------------------


# ---------------------------------------------------
# This is jolly-roger test 1
# ---------------------------------------------------
WJR2="W_JR_2"
MS="${WJR2}/${ORIGMS}"

mkdir "${WJR2}"
echo Copying to $MS
cp -r "${RAWMS}" "${MS}"

fix_ms_dir "$MS"

jolly_tractor \
    tukey \
    $COMMON_JR_OPTS \
    --ignore-nyquist-zone 3 \
    "${MS}"

WSCLEAN_CMD="wsclean ${COMMON_WSCLEAN_OPTS} -data-column JOLLY_DATA -name ${WJR1}/with_jolly2 ${MS}"
apptainer exec $WSCLEAN_CONTAINER $WSCLEAN_CMD
# ---------------------------------------------------







