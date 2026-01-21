  METHOD filter_protocol.

    IF _flg_dsp_all IS INITIAL.
      IF _flg_dsp_err_warn IS NOT INITIAL.
        protocol->filter_protocol_wrt_warn_error( ).
      ELSEIF _flg_dsp_err IS NOT INITIAL.
        protocol->filter_protocol_wrt_error( ).
      ENDIF.
    ENDIF.

  ENDMETHOD.