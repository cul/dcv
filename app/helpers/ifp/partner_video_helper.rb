module Ifp::PartnerVideoHelper

        def ifp_video_list(partner)
		 office_vid = {
		   brazil: 'j3FAzPfdEeY',
		   chile: 'j3FAzPfdEeY',
		   china: 'j3FAzPfdEeY',
		   egypt: 'j3FAzPfdEeY',
		   ghana: 'j3FAzPfdEeY',
		   guatemala: 'j3FAzPfdEeY',
		   india: 'j3FAzPfdEeY',
		   indonesia: 'j3FAzPfdEeY',
		   kenya: 'j3FAzPfdEeY',
		   mexico: 'j3FAzPfdEeY',
		   mozambique: 'j3FAzPfdEeY',
		   nigeria: 'j3FAzPfdEeY',
		   palestine: 'j3FAzPfdEeY',
		   peru: 'j3FAzPfdEeY',
		   philippines: 'j3FAzPfdEeY',
		   russia: 'j3FAzPfdEeY',
		   senegal: 'j3FAzPfdEeY',
		   southafrica: 'j3FAzPfdEeY',
		   tanzania: 'j3FAzPfdEeY',
		   thailand: 'j3FAzPfdEeY',
		   uganda: 'j3FAzPfdEeY',
		   vietnam: 'j3FAzPfdEeY',
		   secretariat: 'j3FAzPfdEeY',
		 }
          return office_vid[partner.to_sym]
        end

end
