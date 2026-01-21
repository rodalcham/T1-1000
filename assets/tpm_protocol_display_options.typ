*&---------------------------------------------------------------------*
*& Include tpm_protocol_display_options
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK output2 WITH FRAME TITLE TEXT-pdo.
    PARAMETERS: x_all TYPE tpm_protocol_display_complete RADIOBUTTON GROUP dlog DEFAULT 'X',
                x_warerr TYPE tpm_protocol_display_err_warn RADIOBUTTON GROUP dlog,
                x_err TYPE tpm_protocol_display_errors RADIOBUTTON GROUP dlog.
SELECTION-SCREEN END OF BLOCK output2.