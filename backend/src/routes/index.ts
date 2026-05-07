import { Router } from "express";
import userRoutes from "../modules/users/user.routes";
import authRoutes from "../modules/auth/auth.routes";
import serviceRoutes from "../modules/providers/service.routes";
import cartRoutes from "../modules/cart/cart.routes";
import bookingRoutes from "../modules/bookings/booking.routes";
import paymentRoutes from "../modules/payments/payment.routes";
import path from "path";

const router = Router();

router.get("/health", (_req, res) => {
    res.status(200).json({
        success: true,
        message: "Server healthy",
    });
});

router.use("/auth", authRoutes);
router.use("/users", userRoutes);
router.use("/services", serviceRoutes);
router.use("/cart", cartRoutes);
router.use("/bookings", bookingRoutes);
router.use(
    "/payments",
    paymentRoutes
);


router.get('/test-payment', (req, res) => {
    res.sendFile(path.join(__dirname, '../../public/test-payment.html'));
});
export default router;