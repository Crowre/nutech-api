export const validateRegistration = (req, res, next) => {
    const { email, password, first_name, last_name } = req.body;

    if (!email || !password || !first_name || !last_name) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter email, password, first_name, dan last_name tidak boleh kosong',
            data: null
        });
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter email tidak sesuai format',
            data: null
        });
    }
    if (password.length < 8) {
        return res.status(400).json({
            status: 102,
            message: 'Password harus memiliki minimal 8 karakter',
            data: null
        });
    }

    next();
};

export const validateLogin = (req, res, next) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter email dan password tidak boleh kosong',
            data: null
        });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter email tidak sesuai format',
            data: null
        });
    }

    next();
};

export const validateTopUp = (req, res, next) => {
    const { top_up_amount } = req.body;

    if (!top_up_amount) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter top_up_amount tidak boleh kosong',
            data: null
        });
    }

    if (top_up_amount < 1 || top_up_amount > 1000000000) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter top_up_amount hanya boleh diisi oleh angka min 1 dan max 1000000000',
            data: null
        });
    }

    next();
};

export const validateTransaction = (req, res, next) => {
    const { service_code } = req.body;

    if (!service_code) {
        return res.status(400).json({
            status: 102,
            message: 'Parameter service_code tidak boleh kosong',
            data: null
        });
    }

    next();
};