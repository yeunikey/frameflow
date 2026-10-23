# Project idea and MVP

[← Documentation](README.md) · [Next: Getting started →](getting-started.md)

## Who it is for

FrameFlow is being developed for small and medium-sized businesses whose staff manually transfer information from PDFs, scans, and images into Excel, 1C, or CRM systems.

The goal is to reduce manual data entry while keeping the source of every value available for review.

## Main workflow

1. Users create output tables and columns, selecting extraction presets such as full name, IIN, address, IBAN, date, and amount.
2. They upload a PDF, JPG, or PNG document.
3. They select regions on the document and link those regions to columns in the output tables.
4. OCR reads the text; NER and type-specific handlers suggest values.
5. Users review values, correct errors, and resolve ambiguous candidates.
6. The system suggests record relationships using configured keys.
7. Users confirm the results and export them to Excel, CSV, or an agreed integration API.

Tables define the output structure, not a required layout in the source document. One paragraph can populate several columns, and several columns can use the same region. Renaming a column does not train a new entity type.

## Example output

| Table | Fields | Relationships |
| --- | --- | --- |
| Customers | Name, IIN, address | A customer can have multiple invoices |
| Invoices | Number, date, amount, customer | Belongs to a customer |
| Transactions | Date, amount, type, invoice | References an invoice |

Customer business records are separate from platform user accounts. Missing or conflicting relationship keys require human review; matching a name alone is insufficient.

## Extraction and templates

The intended pipeline is: region → image preparation → OCR with coordinates → NER and type-specific handlers → normalization → draft values → human review.

PaddleOCR and XLM-RoBERTa are the preliminary foundations. Models are intended to run on our infrastructure and be fine-tuned on suitable data. OpenAI is used separately for summaries and natural-language answers; core extraction does not depend on it.

A template stores table schemas, field settings, and region mappings. It applies to similar documents; layout changes may require adjustment. Normalized coordinates do not guarantee compatibility with arbitrary document layouts.

## First-version scope

The planned MVP includes manual regions, configurable tables, field presets, self-hosted OCR/NER, review and confirmation, templates, record relationships, Excel/CSV exports, and one demonstration connector or sandbox API.

Universal support for arbitrary documents, every CRM and 1C version, complex multipage tables, and general-purpose business process automation is outside the first MVP.
