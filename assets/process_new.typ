METHOD process .
  ...
    " process the positions
    CASE _str_selection-impairment.
      WHEN abap_true.
        process_imp( ).
        filter_protocol( ).
        manage_output_imp( ).

      WHEN abap_false.
        IF is_serial_processing( ).
          process_val_ser( ).
        ELSE.
          process_val_parallel( ).
        ENDIF.
        IF dbt_wrapper IS BOUND.
          DATA(dbt_protocol_handler) = dbt_wrapper->execute( ).
          protocol->merge_protocol_handler( CHANGING ch_protocol_handler = dbt_protocol_handler ).
        ENDIF.
        filter_protocol( ).
        manage_output_val( ).
    ENDCASE.
  ENDMETHOD.