import { Types } from "mongoose";

import { ServiceRepository } from "./service.repository";

import {
    ServiceDocument,
} from "./service.types";

import { AppError } from "../../app/errors/AppError";

import { HTTP_STATUS } from "../../shared/responses/httpStatus";
import { ServiceCategory } from "./service.enums";

export class ServiceService {
    private serviceRepository =
        new ServiceRepository();

    private mapService(
        service: ServiceDocument & {
            _id: Types.ObjectId;
        }
    ) {
        return {
            id: service._id.toString(),

            title: service.title,

            description:
                service.description,

            price: service.price,

            duration: service.duration,

            category: service.category,

            imageUrl:
                service.imageUrl,

            capacityPerSlot:
                service.capacityPerSlot,

            isActive:
                service.isActive,

            createdAt:
                service.createdAt,

            updatedAt:
                service.updatedAt,
        };
    }

    async createService(payload: {
        title: string;

        description: string;

        price: number;

        duration: number;

        category: string;

        imageUrl?: string;

        capacityPerSlot: number;

        createdBy: string;
    }) {
        const service =
            await this.serviceRepository.create({
                ...payload,
                category: payload.category as ServiceCategory,
                createdBy:
                    new Types.ObjectId(
                        payload.createdBy
                    ),
            });

        return this.mapService(service);
    }



    async getServices(params: {
        page: number;

        limit: number;

        search?: string;

        category?: string;
    }) {
        const {
            services,
            total,
        } =
            await this.serviceRepository.findAll(
                params
            );

        const hasMore =
            params.page * params.limit <
            total;

        return {
            services:
                services.map((service) =>
                    this.mapService(service)
                ),

            meta: {
                page: params.page,

                limit: params.limit,

                total,

                hasMore,
            },
        };
    }


    async getServiceById(
        serviceId: string
    ) {
        const service =
            await this.serviceRepository.findActiveById(
                serviceId
            );

        if (!service) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Service not found",
                "SERVICE_NOT_FOUND"
            );
        }

        return this.mapService(service);
    }


    async updateService(
        serviceId: string,
        payload: Partial<ServiceDocument>
    ) {
        const updatedService =
            await this.serviceRepository.update(
                serviceId,
                payload
            );

        if (!updatedService) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Service not found",
                "SERVICE_NOT_FOUND"
            );
        }

        return this.mapService(
            updatedService
        );
    }

    async deactivateService(
        serviceId: string
    ) {
        const service =
            await this.serviceRepository.deactivate(
                serviceId
            );

        if (!service) {
            throw new AppError(
                HTTP_STATUS.NOT_FOUND,
                "Service not found",
                "SERVICE_NOT_FOUND"
            );
        }

        return;
    }
}