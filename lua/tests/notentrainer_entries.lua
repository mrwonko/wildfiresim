entries =
{
	c2 = "C",
	c3 = "C",
	c4 = "C",
	d2 = "D",
	d3 = "D",
	d4 = "D",
	d2 = "E",
	d3 = "E",
	d4 = "E",
	f2 = "F",
	f3 = "F",
	f4 = "F",
	g2 = "G",
	g3 = "G",
	a2 = "A",
	a3 = "A",
	h2 = "H",
	h3 = "H",
}

for k, v in pairs(entries) do
	Entry
	{
		question = "Wie heiﬂt die Note?";
		answer = v;
		image = "notes/"..k..".png";
	}
end