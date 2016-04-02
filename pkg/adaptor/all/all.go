package all

import (
	// Initialize all adapters by importing this package
	_ "github.com/anortef/transporter/pkg/adaptor/elasticsearch"
	_ "github.com/anortef/transporter/pkg/adaptor/file"
	_ "github.com/anortef/transporter/pkg/adaptor/mongodb"
	_ "github.com/anortef/transporter/pkg/adaptor/rethinkdb"
	_ "github.com/anortef/transporter/pkg/adaptor/transformer"
)
