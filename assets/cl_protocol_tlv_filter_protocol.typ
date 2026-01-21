METHOD filter_protocol_wrt_error.

    LOOP AT _tas_protocol_position REFERENCE INTO DATA(l_protocol_position).
      IF l_protocol_position->protocol_handler IS BOUND.
        l_protocol_position->protocol_handler->filter_protocol_wrt_error( ).
      ENDIF.
    ENDLOOP.

    _protocolhandler->filter_protocol_wrt_error( ).

  ENDMETHOD.


  METHOD filter_protocol_wrt_warn_error.

    LOOP AT _tas_protocol_position REFERENCE INTO DATA(l_protocol_position).
      IF l_protocol_position->protocol_handler IS BOUND.
        l_protocol_position->protocol_handler->filter_protocol_wrt_warn_error( ).
      ENDIF.
    ENDLOOP.

    _protocolhandler->filter_protocol_wrt_warn_error( ).

  ENDMETHOD.
