// controllers/bannerController.js
import db from '../config/database.js';
import { successResponse, serverError } from '../utils/responseHelper.js';

export const getBanners = async (req, res) => {
    try {
        const [banners] = await db.execute(
            'SELECT banner_name, banner_image, description FROM banners WHERE is_active = TRUE ORDER BY created_at DESC'
        );

        const formattedBanners = banners.map(banner => ({
            banner_name: banner.banner_name,
            banner_image: banner.banner_image,
            description: banner.description
        }));

        return successResponse(res, formattedBanners);

    } catch (error) {
        return serverError(res, error);
    }
};

export default getBanners;