---
name: Domain Model Serialization
about: Domain model serialization
title: Add Domain Model Serialization
labels: enhancement
assignees: nateklaiber

---

### Tasks

* [ ] Add any corresponding serializers in `lib/naas/serializers/*.rb` to support API endpoints

#### Notes

* This permits serialization as needed from the remote resource. In most cases the remote resource will already have it serialized, and this will provide the wrapper for that serialization. For instance, if the response is CSV, we will wrap that in the ruby CSV object.
