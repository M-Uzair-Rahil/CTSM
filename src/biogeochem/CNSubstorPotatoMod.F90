module CNSubstorPotatoMod

  !-----------------------------------------------------------------------
  ! !DESCRIPTION:
  ! SUBSTOR-Potato helper equations ported from DSSAT SUBSTOR-Potato.
  ! These routines expose the phenology and tuber-demand response functions
  ! while keeping CLM photosynthesis, water stress, nitrogen, and mass balance.
  !-----------------------------------------------------------------------

  use shr_kind_mod, only : r8 => shr_kind_r8

  implicit none
  private

  public :: substor_air_thermal_time
  public :: substor_soil_thermal_time
  public :: substor_relative_temp_factor
  public :: substor_relative_daylength_factor
  public :: substor_tuber_induction_index
  public :: substor_tuber_demand_factor

contains

  real(r8) function substor_air_thermal_time(tmean_c) result(dtt)
    real(r8), intent(in) :: tmean_c

    if (tmean_c <= 2._r8) then
       dtt = 0._r8
    else if (tmean_c <= 17._r8) then
       dtt = 0.0667_r8 * (tmean_c - 2._r8)
    else if (tmean_c <= 24._r8) then
       dtt = 1._r8
    else if (tmean_c <= 35._r8) then
       dtt = 1._r8 - 0.0909_r8 * (tmean_c - 24._r8)
    else
       dtt = 0._r8
    end if
    dtt = max(0._r8, dtt)

  end function substor_air_thermal_time

  real(r8) function substor_soil_thermal_time(tsoil_c) result(stt)
    real(r8), intent(in) :: tsoil_c

    if (tsoil_c >= 2._r8 .and. tsoil_c < 15._r8) then
       stt = 0.0769_r8 * (tsoil_c - 2._r8)
    else if (tsoil_c >= 15._r8 .and. tsoil_c < 23._r8) then
       stt = 1._r8
    else if (tsoil_c >= 23._r8 .and. tsoil_c < 33._r8) then
       stt = 1._r8 - 0.1_r8 * (tsoil_c - 23._r8)
    else
       stt = 0._r8
    end if
    stt = max(0._r8, stt)

  end function substor_soil_thermal_time

  real(r8) function substor_relative_temp_factor(tmin_c, tmax_c, tc) result(rtf)
    real(r8), intent(in) :: tmin_c
    real(r8), intent(in) :: tmax_c
    real(r8), intent(in) :: tc
    real(r8) :: temp

    temp = tmin_c * 0.75_r8 + tmax_c * 0.25_r8
    if (temp <= 4._r8) then
       rtf = 0._r8
    else if (temp <= 10._r8) then
       rtf = 1._r8 - (1._r8 / 36._r8) * (10._r8 - temp)**2
    else if (temp <= tc) then
       rtf = 1._r8
    else if (temp <= tc + 8._r8) then
       rtf = 1._r8 - (1._r8 / 64._r8) * (temp - tc)**2
    else
       rtf = 0._r8
    end if
    rtf = max(0._r8, min(1._r8, rtf))

  end function substor_relative_temp_factor

  real(r8) function substor_relative_daylength_factor(daylength_hours, p2) result(rdlf)
    real(r8), intent(in) :: daylength_hours
    real(r8), intent(in) :: p2

    if (daylength_hours <= 12._r8) then
       rdlf = 1._r8
    else
       rdlf = (1._r8 - p2) + (p2 / 144._r8) * (24._r8 - daylength_hours)**2
       rdlf = max(0._r8, rdlf)
    end if

  end function substor_relative_daylength_factor

  real(r8) function substor_tuber_induction_index(rdlf, rtf, swfac, nstres) result(tii)
    real(r8), intent(in) :: rdlf
    real(r8), intent(in) :: rtf
    real(r8), intent(in) :: swfac
    real(r8), intent(in) :: nstres

    tii = rdlf * rtf + 0.5_r8 * (1._r8 - min(swfac, nstres))

  end function substor_tuber_induction_index

  real(r8) function substor_tuber_demand_factor(dt1, dt2, dt3, xstage, pd, nfac) result(tind)
    real(r8), intent(in) :: dt1
    real(r8), intent(in) :: dt2
    real(r8), intent(in) :: dt3
    real(r8), intent(in) :: xstage
    real(r8), intent(in) :: pd
    real(r8), intent(in) :: nfac
    real(r8) :: deveff
    real(r8) :: dtii_avg

    deveff = min((xstage - 2._r8) * 10._r8 * pd, 1._r8)
    dtii_avg = (dt1 + dt2 + dt3) / 3._r8
    if (nfac > 1._r8) then
       tind = dtii_avg * (1._r8 / nfac) * deveff
    else
       tind = dtii_avg * deveff
    end if
    tind = max(0._r8, min(1._r8, tind))

  end function substor_tuber_demand_factor

end module CNSubstorPotatoMod
