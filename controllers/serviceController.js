// controllers/serviceController.js
import db from '../config/database.js';
import { successResponse, serverError } from '../utils/responseHelper.js';

export const getServices = async (req, res) => {
    try {
        const [services] = await db.execute(
            'SELECT service_code, service_name, service_icon, service_tariff FROM services WHERE is_active = TRUE ORDER BY service_name ASC'
        );

        const formattedServices = services.map(service => ({
            service_code: service.service_code,
            service_name: service.service_name,
            service_icon: service.service_icon,
            service_tariff: service.service_tariff
        }));

        return successResponse(res, formattedServices);

    } catch (error) {
        return serverError(res, error);
    }
};

export default getServices;