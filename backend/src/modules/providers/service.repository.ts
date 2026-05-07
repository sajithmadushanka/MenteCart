import {
    QueryFilter,
    Types,
} from "mongoose";

import {
    ServiceModel,
} from "./service.model";

import {
    ServiceDocument,
} from "./service.types";

export class ServiceRepository {
    async create(
        payload: Partial<ServiceDocument>
    ) {
        return ServiceModel.create(
            payload
        );
    }
    async findById(serviceId: string) {
        return ServiceModel.findById(
            serviceId
        ).exec();
    }
    async findActiveById(
        serviceId: string
    ) {
        return ServiceModel.findOne({
            _id: serviceId,

            isActive: true,
        }).exec();
    }

    async findAll(params: {
        page: number;

        limit: number;

        search?: string;

        category?: string;
    }) {
        const {
            page,
            limit,
            search,
            category,
        } = params;

        const filter: QueryFilter<ServiceDocument> =
        {
            isActive: true,
        };

        if (category) {
            filter.category = category as any;
        }

        if (search) {
            filter.$text = {
                $search: search,
            };
        }

        const skip =
            (page - 1) * limit;

        const [services, total] =
            await Promise.all([
                ServiceModel.find(filter)
                    .sort({
                        createdAt: -1,
                    })
                    .skip(skip)
                    .limit(limit)
                    .exec(),

                ServiceModel.countDocuments(
                    filter
                ),
            ]);

        return {
            services,

            total,
        };
    }

    async update(
        serviceId: string,
        payload: Partial<ServiceDocument>
    ) {
        return ServiceModel.findByIdAndUpdate(
            serviceId,
            payload,
            {
              returnDocument: "after"
            }
        ).exec();
    }
    async deactivate(
        serviceId: string
    ) {
        return ServiceModel.findByIdAndUpdate(
            serviceId,
            {
                isActive: false,
            },
            {
               returnDocument: "after"
            }
        ).exec();
    }
}