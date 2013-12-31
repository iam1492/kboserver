class MyWedding < Wedding

	def save_the_date
		year  = 2014
		month = "February"
		day   = 16
		time  = "12:00pm"
	end

	def marrage (love)
		male   = "Wooram"
		female = "Sunyoung"

		if (love == true)
			return male + female
		else
			return RuntimeMarriageException("T_T")
	end
end

