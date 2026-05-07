import {
    Request,
    Response,
} from "express";

import { ServiceService } from "./service.service";

import { successResponse } from "../../shared/responses/apiResponses";
import { HTTP_STATUS } from "../../shared/responses/httpStatus";

export class ServiceController {
    private serviceService =
        new ServiceService();

    createService = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const service =
            await this.serviceService.createService(
                {
                    ...req.body,

                    createdBy:
                        req.user!.userId,
                }
            );

        res.status(
            HTTP_STATUS.CREATED
        ).json(
            successResponse(
                service,
                "Service created successfully"
            )
        );
    };

    getServices = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const page = Number(
            req.query.page || 1
        );

        const limit = Number(
            req.query.limit || 10
        );

        const result =
            await this.serviceService.getServices(
                {
                    page,

                    limit,

                    search:
                        req.query.search as string,

                    category:
                        req.query.category as string,
                }
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                result,
                "Services fetched successfully"
            )
        );
    };

    getServiceById = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id =
            Array.isArray(req.params.id)
                ? req.params.id[0]
                : req.params.id;

        const service =
            await this.serviceService.getServiceById(
                id
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                service,
                "Service fetched successfully"
            )
        );
    };

    updateService = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id =
            Array.isArray(req.params.id)
                ? req.params.id[0]
                : req.params.id;

        const service =
            await this.serviceService.updateService(
                id,
                req.body
            );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                service,
                "Service updated successfully"
            )
        );
    };

    deactivateService = async (
        req: Request,
        res: Response
    ): Promise<void> => {
        const id =
            Array.isArray(req.params.id)
                ? req.params.id[0]
                : req.params.id;


        await this.serviceService.deactivateService(
            id
        );

        res.status(HTTP_STATUS.OK).json(
            successResponse(
                null,
                "Service deactivated successfully"
            )
        );
    };
}