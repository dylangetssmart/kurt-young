select distinct
	kind
from [KurtYoung_Needles]..negotiation n
where
	ISNULL(kind, '') <> ''
order by n.kind