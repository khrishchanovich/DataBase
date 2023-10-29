SELECT COUNT(DISTINCT CateogyId) AS CategoryId,
	SUM(Rate),
    MIN(Rate) AS Min,
    MAX(Rate) AS Max,
    AVG(Rate) AS Average
FROM InsuranceType;