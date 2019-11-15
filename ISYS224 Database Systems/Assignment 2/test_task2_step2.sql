UPDATE invoice
SET invoice.STATUS = 'OVERDUE'
WHERE invoice.STATUS <> 'OVERDUE' AND invoice.INVOICENO > 0;